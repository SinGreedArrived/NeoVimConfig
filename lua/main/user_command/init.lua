-- golang group
local attach_to_buffer = function(output_bufnr, command)
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = golang,
        pattern = "*.go",
        callback = function()
            local append_data = function(_, data)
                if data then
                    vim.api
                        .nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
                end
            end

            vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false,
                                       {"main.go output:"})
            vim.fn.jobstart(command, {
                stdout_buffered = true,
                on_stdount = append_data,
                on_stderr = append_data
            })
        end
    })
end
