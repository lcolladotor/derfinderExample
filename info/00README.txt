###-  HapMap individual genotypes -### 

This directory contains information on the family relationships in 
pedigrees for the samples genotyped in the HapMap Project. Note 
that only the Youruba and CEPH individuals are mother-father-child
trios; the Japanese and Chinese are unrelated.

File formats:

  individuals*.xml, samples*.xml: XML files conforming to the 
    HapMap XML schema.
  
  pedinfo2sample*.txt: pedigree information on each sample, linked
    up with sample & individual LSID
    Col1: family pedID [empty for unrelateds]
    Col2: individual pedID [always 1 for unrelateds]
    Col3: father pedID (0 if founder)
    Col4: mother pedID (0 if founder)
    Col5: sex (1=male, 2=female)
    Col6: individual LSID (assigned by DCC)
    Col7: sample LSID (assigned by DCC based on Coriell catalog IDs)

The same population abbreviations are used in filenames as elsewhere on
this website:
CEU: CEPH (Utah residents with ancestry from northern and western Europe)
HCB: Han Chinese in Beijing, China
JPT: Japanese in Tokyo, Japan
YRI: Yoruba in Ibadan, Nigeria



------------------------------
info@hapmap.org
