function Files = ExcludeFoldersFromFiles(FilesAndFolders)

FileIndices = [];
for i = 1:length(FilesAndFolders)
    if (FilesAndFolders(i).isdir == 0)
        FileIndices = [FileIndices; i];
    end
end
Files = FilesAndFolders(FileIndices);

end