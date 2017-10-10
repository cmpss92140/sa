#! /bin/sh




ls -ARl | awk '/^[-d]/' | sort -k 5 -n -r | awk 'BEGIN { f_count=0; d_count=0; total_count=0;} { if( NR <= 5 ) print NR ":" $5 " " $9; \
 if( $1 ~ /^-/ ) {f_count=f_count+1;  total_count=total_count+$5};if( $1 ~ /^d/ ) {d_count=d_count+1;}} END { print "Dir num:" d_count "\n"\
"File num:" f_count "\n" "Total:" total_count}'

