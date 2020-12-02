
count=0
while read l ; do
    s=${l%-*}
    e=${l% * *}
    e=${e/*-/}
    c=${l%:*}
    c=${c/* /}
    pw=${l#* * }
    # echo $s $e $c $pw
    this=$(($(echo $pw | sed -e "s/$c/+1/g" -e "s/[a-z]//g") ))
    if [[ $s -le $this ]] && [[ $this -le $e ]] ; then
        count=$((count + 1))
    fi
done

echo $count
