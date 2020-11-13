import Bio
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
from Bio.Seq import Seq
input_file = input("Write the path to your fasta sequence: ")
output_file = input("Name the fasta sequence reordered: ")
restriction = input("Write the place where it has to start reordering the sequence: ")

with open(output_file, "w") as f:
	for seq_record in SeqIO.parse(input_file, "fasta"):
		cut = seq_record.seq.find(restriction)
		f.write(">" + str(seq_record.id) + "\n" + 
		str(seq_record.seq[cut:]) + str(seq_record.seq[:cut]) + "\n")
print("The reordering should be done, restart the script to reorder another fasta sequence")
