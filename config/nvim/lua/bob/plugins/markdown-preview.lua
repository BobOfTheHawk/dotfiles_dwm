return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        ft = { "markdown" },
        keys = {
            { "<leader>md", "<cmd>MarkdownPreviewToggle<cr>", desc = "markdown preview" },
        },
    },
}
