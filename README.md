# Folder Merge

Currently work in progress

This is a small ruby terminal app designed to analyse sync folders that have diverged.

- It uses a files path to see if it exists in the same location in both trees.
- It uses a files path and SHA1 Hash to see if it exists in the same location in both trees but has been modified.
- It uses a files SHA1 Hash to see if a file exists in both trees but at different paths (eg file has moved within tree)