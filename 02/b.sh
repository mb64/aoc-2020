
count=0
while read l ; do
    s=${l%-*}
    e=${l% * *}
    e=${e/*-/}
    c=${l%:*}
    c=${c/* /}
    pw=${l#* * }
    first=$(echo $pw | sed -Ee "s/.{$((s - 1))}// ; T end" -e 's/(.).*/\1/' -e ':end' )
    second=$(echo $pw | sed -Ee "s/.{$((e - 1))}// ; T end" -e 's/(.).*/\1/' -e ':end' )
    if [ $first = $c ] || [ $second = $c ] ; then
        if ! [ $first = $c ] || ! [ $second = $c ] ; then
            # echo $first $second $c
            count=$((count + 1))
        fi
    fi
done

echo $count
