#!/bin/bash

# Input of names from files that contain the reference sequence/genome
# and the target sequences

read -p 'Input the path: ' path
if [[ -d $path ]]; then
	echo 'Path loaded succesfully'
else
	until [[ -d $path ]]; do
		read -p 'Path not found, try again: ' path
	done
	echo 'Path loaded succesfully'
fi
cd $path


read -p 'Input the reference genome/sequence: ' ref
if [[ -f $ref ]]; then
	echo 'Reference genome/sequence loaded'
else
	until [[ -d $ref ]]; do
		read -p 'Path not found, try again: ' ref
	done
	echo 'Reference genome/sequence loaded'
fi


read -p 'Input file with sequences to align with reference: ' seq
if [[ -f $seq ]]; then
	echo 'Sequences loaded'
else
	until [[ -d $seq ]]; do
		read -p 'Path not found, try again: ' seq
	done
	echo 'Sequences loaded'
fi

# Sequence alignment with reference genome/sequence

## Index the reference genome/sequence
bwa index $ref

## Sequence alignment with the reference sequence

bwa mem $ref $seq > ${seq%%.*}.sam

## sam to bam conversion
samtools view -S -b ${seq%%.*}.sam > ${seq%%.*}.bam

## Ordering of bam coordinates:
samtools sort -o ${seq%%.*}_s.bam ${seq%%.*}.bam


# Variant detection

## Calculate read coverage position in the reference sequence
bcftools mpileup -O b -o ${seq%%.*}_raw.bcf -f $ref ${seq%%.*}_s.bam

## Variant detection:
bcftools call -mv -o ${seq%%.*}_var.vcf ${seq%%.*}_raw.bcf

## Filter and report of SNP variants in vcf format
vcfutils.pl varFilter ${seq%%.*}_var.vcf > ${seq%%.*}_final.vcf

echo 'End of script, to generate more vcf files restart again.'
