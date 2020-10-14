taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic
# derived from  taxa so that it maps order names to sets of taxa.
#
# An example output is:
#
# 'Chiroptera' : set(['Myotis lucifugus']) ... etc.
#  OR,
# 'Chiroptera': {'Myotis lucifugus'} ... etc

#taxa_dic = {row[1]: row[0] for row in taxa if row[1] not in taxa_dic }

taxa_dic = {}
for row in taxa:
    taxa_dic.setdefault(row[1], []).append(row[0])
print(taxa_dic)

#setdefault creates a new key only if it doesn't exist in the format (key, value)
#setting the value to an empty list when creating the key allows appending of
#multiple values per key
