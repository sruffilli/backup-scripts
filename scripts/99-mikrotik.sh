#!/bin/bash -x

DST=/backups/mikrotik
mkdir -p $DST

echo "*** $(date -u) Exporting Mikrotic configs to $DST"

ssh -o StrictHostKeyChecking=no admin@192.168.1.1 export > $DST/diaz.rst
ssh -o StrictHostKeyChecking=no admin@192.168.2.1 export > $DST/milano.rst
ssh -o StrictHostKeyChecking=no admin@192.168.100.1 export > $DST/newco.rst
