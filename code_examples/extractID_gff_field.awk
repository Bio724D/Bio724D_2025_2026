BEGIN {
    FS = "\t"
}


/##FASTA/ { exit }
/^#/ { next }
NF < 9 { next } # skip any badly formed entries

$3 == "gene" {
    match($9, /ID=([^;]+);/, idarray)

    print $1, $3, $4, $5, idarray[1]
}
