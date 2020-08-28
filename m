Return-Path: <aherrmann@suse.com>
Date: Fri, 28 Aug 2020 12:02:30 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 0/2] cgroup: Enable weight tests with cgroup-v2
Message-ID: <20200828100230.GG6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Return-Path: aherrmann@suse.com
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,

To allow tests with weight attribute with cgroup-v2
it would be nice to be able to specify which attribute
to use -- either the generic or the BFQ specific one.
Patch #1 adds an option to do that.
Patch #2 enables tests with cgroup.weight when cgroup-v2 is used.

--=20
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer (HRB 36809, AG N=C3=BCrnberg)


