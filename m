Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB1116D372A224C01B8CEED04281AB0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB11163E6C999998E0A2F13F9E81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB111689EE46B3839EB0675D7B81F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116307F93264CDB7F09870981F70@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhHoS62hDsz9cvwjYBJFODDZ6EvTry9u4nErXAC67JwKg@mail.gmail.com>
 <CY1PR0401MB111673C9DC353353BACFCE5B81F50@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116FC09283C22316161F3E381CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgi-muVZ4XVF53amSHOzLjMEDSY2Z2GRmKso_VZ1sVazA@mail.gmail.com>
 <CY1PR0401MB11163A5F0CE792CC28A7252D81CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxiso_3xAjP1CJ91=qXcsyKcwzN2XfBeGLvPzeMj45BLGQ@mail.gmail.com>
 <CY1PR0401MB111641A66DF1AC0E016E97E181CE0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjmz4t_rbXuDwqPmiAPXUg_h88qvcRUGbXPCRAnDcw8Qg@mail.gmail.com>
 <CY1PR0401MB1116F8AD0CBB303383918EA481C10@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxg0pNhmSnvRGDL7um-KhX8eqwHfk1T8CSaQYih2c8p33Q@mail.gmail.com>
 <CY1PR0401MB111655928AE4688373702CEB81D00@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxgtTM--wW-NwkDe_5RWGeZQ=FUQUH_HXK8hOsci5pDpxA@mail.gmail.com>
 <CY1PR0401MB1116782C9FD301E23D24A4A281D40@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CY1PR0401MB1116D372A224C01B8CEED04281AB0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 22 Mar 2018 14:47:16 +0000
Message-ID: <CALjAwxgyTBM3C09bGJ5ivqxCh2ghDCVy=U-tVOudL5uN6Y1zsA@mail.gmail.com>
Subject: Re: fiologparser_hist.py script patch and enhancements?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 20 March 2018 at 05:57, Kris Davis <Kris.Davis@wdc.com> wrote:
> I created a pull request from github with the latest changes, both to fio=
logparser_hist.py and the associated man page.   This includes a new "--dir=
ections=3Drwtm" option to allow independent directional results to be print=
ed (with an added 'dir' column).

I see Jens pulled it in so congrats on staying the course!

> If there is a way to infer whether the histogram results are in 'ns' or '=
ms' from the number of columns, please let me know.  I wonder if the 'coars=
eness' option might be a factor they might complicate things.  I'm mostly r=
elying on the original script operation, rather than having a more complete=
 understanding of the dependencies.

The coarseness definitely complicates things but here are my thoughts:

If you know the total columns and you're willing to assume fio compile
defaults you can try and guess whether FIO_IO_U_PLAT_GROUP_NR is 19
(in which case you assume usec) or 29 (in which case you assume nsec).

From iolog.c:
 723         int stride =3D 1 << hist_coarseness;
[...]
 734                 s =3D __get_sample(samples, log_offset, i);
 735
 736                 entry =3D s->data.plat_entry;
 737                 io_u_plat =3D entry->io_u_plat;
 738
 739                 entry_before =3D flist_first_entry(&entry->list,
struct io_u_plat_entry, list);
 740                 io_u_plat_before =3D entry_before->io_u_plat;
 741
 742                 fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
 743                                                 io_sample_ddir(s), s->=
bs);
 744                 for (j =3D 0; j < FIO_IO_U_PLAT_NR - stride; j +=3D st=
ride) {
 745                         fprintf(f, "%llu, ", (unsigned long long)
 746                                 hist_sum(j, stride, io_u_plat,
io_u_plat_before));
 747                 }
 748                 fprintf(f, "%llu\n", (unsigned long long)
 749                         hist_sum(FIO_IO_U_PLAT_NR - stride,
stride, io_u_plat,
 750                                         io_u_plat_before));

So we can tell the number of columns is related to the 3 +
(FIO_IO_U_PLAT_NR / (2 ^ coarseness)) + 1. The 3 comes from printing
the time, the data direction and the blocksize columns. In python

def main():
    for pgn in [19, 29]:
        print("pgn=3D%d:" % (pgn)),
        for c in range(7):
            pn =3D (1 << 6) * pgn
            s =3D (1 << c)
            print(((pn - s) / s) + 4),
        print("")

if __name__ =3D=3D "__main__":
    main()

prints the following:
pgn=3D19: 1219 611 307 155 79 41 22
pgn=3D29: 1859 931 467 235 119 61 32

Quick comparison:
$ ./fio --version
fio-3.5-70-g40f1
$ ./fio --name=3Dtest --rw=3Dread --runtime=3D200ms --time_based
--filename=3D/tmp/fio.tmp --size=3D1M --write_hist_log=3Dtest
--log_hist_msec=3D100 --log_hist_coarseness=3D0
$ head -1 test_clat_hist.1.log | awk -F',' '{print NF}'
1859
./fio --name=3Dtest --rw=3Dread --runtime=3D200ms --time_based
--filename=3D/tmp/fio.tmp --size=3D1M --write_hist_log=3Dtest
--log_hist_msec=3D100 --log_hist_coarseness=3D6
$ head -1 test_clat_hist.1.log | awk -F',' '{print NF}'
32

If we approximate the equation we get
((64 * FIO_IO_U_PLAT_GROUP_NR) / (2 ^ coarseness)) + 4 =3D total_columns;
which can be rearranged to
(64 * FIO_IO_U_PLAT_GROUP_NR) / (total_columns - 4) =3D (2 ^ coarseness)
log2((64 * FIO_IO_U_PLAT_GROUP_NR) / (total_columns - 4) =3D coarseness

This allows us to guess and check a bit quicker. For example with
FIO_IO_U_PLAT_GROUP_NR=3D19, columns=3D611

import math

def check_columns(column_actual, pgn_guess):
    approx_coarse_guess =3D int(math.log((64 * pgn_guess) /
float(column_actual - 4), 2))
    stride_guess =3D 1 << approx_coarse_guess
    column_guess =3D ((64 * pgn_guess - stride_guess) / stride_guess) + 4
    return column_guess =3D=3D column_actual

>>> check_columns(611, 19)
True

A bigger test:
>>> [check_columns(x, 19) for x in (1219, 611, 307, 155, 79, 41, 22)]
[True, True, True, True, True, True, True]
>>> [check_columns(x, 19) for x in (1859, 931, 467, 235, 119, 61, 32)]
[False, False, False, False, False, False, False]

If someone explicitly sets --group_nr they ought to set whether the
time is in usec or nsec (or generally override the default) as we
can't really guess any more.

What do you think?

--=20
Sitsofe | http://sucs.org/~sits/

