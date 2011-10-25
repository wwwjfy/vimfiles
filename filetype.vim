" if exists("did_load_myfiletypes")
"     finish
" endif
" let did_load_myfiletypes = 1

augroup filetypedetect
au BufNewFile,BufReadPost *.hdf setf hdf
au BufNewFile,BufReadPost *.cst setf cs
au BufNewFile,BufReadPost *.lzx setf lzx
au BufNewFile,BufReadPost *.as setf actionscript
au BufNewFile,BufReadPost *.m setf objc
augroup END
