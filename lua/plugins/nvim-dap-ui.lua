return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"mfussenegger/nvim-dap",
		{
			"jay-babu/mason-nvim-dap.nvim",
			dependencies = { "williamboman/mason.nvim" },
			opts = {
				ensure_installed = { "php", "python", "delve" },
				handlers = {},
			},
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
	},
	keys = {
		-- F-keys (IDE-standard)
		{ "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
		{ "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		-- Leader-based
		{ "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Conditional Breakpoint" },
		{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
		{ "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
		{ "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
		{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
		{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle UI" },
		{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "REPL" },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
		{ "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Value" },
		{ "<leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end, desc = "Scopes" },
		{ "<leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end, desc = "Frames" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- DAP UI layout
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.35 },
						{ id = "breakpoints", size = 0.15 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					position = "left",
					size = 40,
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					position = "bottom",
					size = 10,
				},
			},
		})

		-- Auto open/close UI
		dap.listeners.before.attach.dapui_config = function() dapui.open() end
		dap.listeners.before.launch.dapui_config = function() dapui.open() end
		dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
		dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

		-- Breakpoint signs
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

		-- PHP adapter (XDebug)
		dap.adapters.php = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
		}
		dap.configurations.php = {
			{
				type = "php",
				request = "launch",
				name = "Listen for XDebug (local)",
				port = 9003,
			},
			{
				type = "php",
				request = "launch",
				name = "Listen for XDebug (Docker)",
				port = 9003,
				pathMappings = {
					["/var/www/html"] = "${workspaceFolder}",
				},
			},
		}

		-- Python adapter (debugpy)
		dap.adapters.python = function(cb, config)
			if config.request == "attach" then
				cb({
					type = "server",
					port = config.port or 5678,
					host = config.host or "127.0.0.1",
				})
			else
				cb({
					type = "executable",
					command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
					args = { "-m", "debugpy.adapter" },
				})
			end
		end

		local function python_path()
			local cwd = vim.fn.getcwd()
			for _, dir in ipairs({ "venv", ".venv" }) do
				local path = cwd .. "/" .. dir .. "/bin/python"
				if vim.fn.executable(path) == 1 then
					return path
				end
			end
			return "python3"
		end

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				pythonPath = python_path,
			},
			{
				type = "python",
				request = "launch",
				name = "Launch file with args",
				program = "${file}",
				args = function()
					local input = vim.fn.input("Arguments: ")
					return vim.split(input, " ", { trimempty = true })
				end,
				pythonPath = python_path,
			},
			{
				type = "python",
				request = "attach",
				name = "Remote attach",
				host = "127.0.0.1",
				port = 5678,
			},
		}

		-- Go adapter (delve)
		dap.adapters.delve = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv",
				args = { "dap", "-l", "127.0.0.1:${port}" },
			},
		}
		dap.configurations.go = {
			{
				type = "delve",
				name = "Debug file",
				request = "launch",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Debug module",
				request = "launch",
				program = "${workspaceFolder}",
			},
			{
				type = "delve",
				name = "Debug test",
				request = "launch",
				mode = "test",
				program = "${file}",
			},
			{
				type = "delve",
				name = "Remote attach",
				request = "attach",
				mode = "remote",
				host = "127.0.0.1",
				port = 38697,
			},
		}
	end,
}
