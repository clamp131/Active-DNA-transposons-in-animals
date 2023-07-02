from pysam import AlignedSegment, AlignmentFile


def get_strand(read: AlignedSegment) -> str:
    if read.is_reverse:
        return "-"
    else:
        return "+"


def get_duplicate(read: AlignedSegment) -> int:
    if read.has_tag("DS"):
        return read.get_tag("DS")
    else:
        return 1


def get_diff(read: AlignedSegment) -> int:
    diff = read.get_tag("NM")
    for (operation, count) in read.cigartuples:
        if operation == 4:
            diff += count
    return diff


n_pairs, n_clipped, n_mismatch, n_pass = 0, 0, 0, 0

with AlignmentFile(snakemake.input[0]) as samfile, open(snakemake.output[0], 'w') as outfile:
    read: AlignedSegment
    unpairedreads: dict[str:AlignedSegment] = {}
    for read in samfile.fetch(until_eof=True):
        if not read.is_proper_pair or read.is_duplicate or read.is_secondary:
            continue
        read_name = read.query_name
        if read_name not in unpairedreads:
            unpairedreads[read_name] = read
            # print(unpairedreads.keys())
            continue
        prev_read = unpairedreads.pop(read_name)
        read1, read2 = (read, prev_read) if read.is_read1 else (
            prev_read, read)

        n_pairs += 1

        cigar2 = read2.cigartuples
        if read2.is_reverse:
            cigar2 = cigar2[::-1]
        operation, count = cigar2[0]
        if operation != 0:
            n_clipped += 1
            continue

        if get_diff(read1) > 5 or get_diff(read2) > 5:
            n_mismatch += 1
            continue

        assert(read1.reference_name == read2.reference_name)
        print(
            read_name, get_duplicate(read1), read1.reference_name,
            read1.reference_start, read1.reference_end, get_strand(read1),
            read1.cigarstring, read1.get_tag("NM"), read1.query_length,
            read2.reference_start, read2.reference_end, get_strand(read2),
            read2.cigarstring, read2.get_tag("NM"), read2.query_length,
            sep="\t", file=outfile
        )
        n_pass += 1

assert(len(unpairedreads) == 0)

with open(snakemake.log[0], 'w') as logfile:
    print(f"valid pairs: {n_pairs}", file=logfile)
    print(f"clipped: {n_clipped}", file=logfile)
    print(f"too many mismatch: {n_mismatch}", file=logfile)
    print(f"passed: {n_pass}", file=logfile)
