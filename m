Return-Path: <Konstantin.Ruvinsky@emc.com>
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Wed, 2 Oct 2013 10:11:09 -0400
Subject: RE: [PULL REQUEST] Man page updates
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C8324A5C8540@MX44A.corp.emc.com>
References: <1380661774.14931.YahooMailNeo@web124903.mail.ne1.yahoo.com>
 <EEF9E3C12F20174DA289A981D6CCA6C8324A5C8515@MX44A.corp.emc.com>
In-Reply-To: <EEF9E3C12F20174DA289A981D6CCA6C8324A5C8515@MX44A.corp.emc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Jens Axboe (axboe@kernel.dk) (axboe@kernel.dk)" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi,

One more fix in the latest HowTo - the last 2 lines are redundant:

verify_backlog=3Dint	Fio will normally verify the written contents of a
		job that utilizes verify once that job has completed. In
		other words, everything is written then everything is read
		back and verified. You may want to verify continually
		instead for a variety of reasons. Fio stores the meta data
		associated with an IO block in memory, so for large
		verify workloads, quite a bit of memory would be used up
		holding this meta data. If this option is enabled, fio
		will write only N blocks before verifying these blocks.

		will verify the previously written blocks before continuing
		to write new ones.

Regards
Konstantin

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Ruvinsky, Konstantin
Sent: Wednesday, October 02, 2013 8:48 AM
To: Sitsofe Wheeler; fio@vger.kernel.org; Jens Axboe (axboe@kernel.dk) (axb=
oe@kernel.dk)
Subject: RE: [PULL REQUEST] Man page updates

Hi Sitsofe and Jens,=20

If you correct the man pages, please remove the second redundant definition=
 of write_bw_log:

write_bw_log=3Dstr If given, write an IOPS log of the jobs in this job
      		file. See write_bw_log.

Regards
Konstantin

-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Sitsofe Wheeler
Sent: Wednesday, October 02, 2013 12:10 AM
To: fio@vger.kernel.org
Subject: [PULL REQUEST] Man page updates

Hi,

This branch updates the man page to better match recent versions of fio.

The following changes since commit de8f6de97438d5664cd8765e60102b9109a273e2=
:

=A0 Fix misspellings using 'codespell' tool (2013-09-27 08:28:55 -0600)

are available in the git repository at:

=A0 https://github.com/sitsofe/fio.git manpage

for you to fetch changes up to fa769d44024be720f5775ea361d55b91e2fcc14e:

=A0 Update man page (2013-09-30 11:54:10 +0100)

----------------------------------------------------------------
Sitsofe Wheeler (2):
=A0 =A0 =A0 Update man page
=A0 =A0 =A0 Update man page

=A0fio.1 | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
=A01 file changed, 52 insertions(+), 3 deletions(-)
=A0
Sitsofe
--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html


