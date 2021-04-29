Return-Path: <prvs=7461fe506=Jeff.Lien@wdc.com>
From: Jeffrey Lien <Jeff.Lien@wdc.com>
Subject: FIO ZNS Write Behavior not Matching Read Behavior
Date: Thu, 29 Apr 2021 14:17:17 +0000
Message-ID: 
 <BYAPR04MB565648B0397EEA4E85B11EDFEA5F9@BYAPR04MB5656.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: Brandon Paupore <Brandon.Paupore@wdc.com>, Andy Hibbard <Andy.Hibbard@wdc.com>
List-ID: <fio@vger.kernel.org>

I have a question on why the ZNS write behavior does not match the read beh=
avior.  In write workloads with an offset that results in a starting lba th=
at is not on a zone boundary, the offset is rounded up to the next zone sta=
rting lba.  This is not done for read workloads though.  I'd like to know i=
f there is a particular reason why or could I change this behavior to be th=
e same for both reads and writes.    =20

This code from the zbd_verify_sizes is doing the round up on writes:
			if ((f->file_offset !=3D z->start) &&
			    (td->o.td_ddir !=3D TD_DDIR_READ)) {
				new_offset =3D zbd_zone_end(z);
				if (new_offset >=3D f->file_offset + f->io_size) {
					log_info("%s: io_size must be at least one zone\n",
						 f->file_name);
					return false;
				}
				log_info("%s: rounded up offset from %llu to %llu\n",
					 f->file_name, (unsigned long long) f->file_offset,
					 (unsigned long long) new_offset);
				f->io_size -=3D (new_offset - f->file_offset);
				f->file_offset =3D new_offset;
			}

This causes a problem for one of our particular testcases that writes a par=
ticular pattern at an offset that ends up being rounded up to the next zone=
 starting lba.  In the 2nd step of this testcase, a read with verify worklo=
ad is done to verify the write workload.  This fails with a miscompare beca=
use the read workload is not starting at the same offset as the write workl=
oad.  Both fio workloads have "offset =3D 1%".=20

Jeff Lien
eSSD Core SW Tools & Drivers

Western Digital
2900 37th St NW
Building 108-1
Rochester, MN 55901
Email:  Jeff.Lien@wdc.com
Office: +1-507-322-2416



