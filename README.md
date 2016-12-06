```
stack build
stack exec prtt-exe
```

```
git log --format='{ "sha": "%H", "datetime": "%aI", "author": "%an", "message": "%s %D" }' --since "2016-11-01" --until "2016-11-30" --author="yulii" --no-merges > commit.json
```
