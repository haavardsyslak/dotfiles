
function pdf_open()
   local bufname = vim.fn.expand("%:t:r") 

   local pdfpath = vim.fn.findfile(bufname .. ".pdf")

   if pdfpath ~= "" then
        vim.fn.system(string.format("zathura './%s' & disown", pdfpath))

    else
        vim.notify("file not found: " .. bufname .. ".pdf")
   end

end
