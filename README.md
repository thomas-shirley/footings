
# Footings

So you have a pile of articles/posts/essays written as Markdown files? You want a quick and easy way to process them into .HTML pages and to build a page index at the same time? 

*Footings* can help.

This project is a fork of [ssg7](https://github.com/rtfmexe/ssg7).

### Features
 - UK Date formats
 - Organises posts into date folders. For example, 
 ```
 01-01-2025 > my-cool-blog-post-about-planes.html
 07-03-2025 > my-long-post-about-boats.html
 ```
 - The blog/site config itself is configured inside the script itself, take a peek:

 ```
sitename="sitename"
baseurl="https://example.org"
lang="en"
 ```

### Requirements
- Bash 3.2
- [Markdown installed](https://#.com)

### Usage
Your posts must be formatted like this (using a sane date format):

```
DD-MM-YYYY.posttitle.md
```
e.g.
```
30-11-1950.This-is-my-post-title.md
```

Then run the script:
```bash
./footings.sh path/to/markdown path/to/output/
```

### Quirks
Make sure that you only have 1 x h1 element in your Markdown documents. Otherwise the script will error as it wont be able to discern the document title.

You are free to amend the template.html and posts.html page, to add your own css styles.

