# New Post
# --------
title='"How old is the Universe"'  # to display
title2='how-old-is-the-universe'   # for file name

categories='fun cloud useless'

today=$(date "+%Y-%m-%d %H:%M:%S +%z")
today2=$(date "+%Y-%m-%d")

postfile="_posts/$today2-$title2.md"

echo "---" > $postfile
echo "layout: post" >> $postfile
echo "title: $title" >> $postfile
echo "date: $today" >> $postfile
echo "categories: $categories" >> $postfile
echo "---" >> $postfile

ll $postfile
cat $postfile
