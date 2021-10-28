# Bible Search
[Biblesearch](https://code.theres.life/heb12/bsearchpyjs/) is a Javascript/Python program that indexes the Bible for quick searching.  

## Parameters
| Parameter | Description |
| ----- | ----- |
| words | Accepts search keywords seperated by space (or %20). |
| length | Return short or long book names (Gen, Genesis). Accepts values "long" and "short" |
| callback | JSONP callback, if you want to include it in script tags |
| page | Page slicing, TODO |

## Examples
https://api.heb12.com/search?words=for%20god%20so%20loved%20the%20world

# Bible Get
Get Bible references, currently under [construction](https://code.theres.life/heb12/cbibleget).  
| Parameter | Description |
| --------- | ----------- |
| reference | Accepts a reference parsable by fbrp. |

It returns a large JSON structure, which fairly easy to parse.