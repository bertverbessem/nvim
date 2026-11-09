-- Add filetypes
vim.filetype.add({
    extension = {
        j2 = "jinja",
        jinja2 = "jinja",
    },
    pattern = {
        ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
        ["[Jj]enkinsfile.*"] = "groovy",
        ["[Dd]ockerfile.*"] = "dockerfile",
    },
})
