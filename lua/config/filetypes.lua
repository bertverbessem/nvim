-- Add filetypes
vim.filetype.add({
    pattern = {
        ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
        ["[Jj]enkinsfile.*"] = "groovy",
        ["[Dd]ockerfile.*"] = "dockerfile",
    },
})
