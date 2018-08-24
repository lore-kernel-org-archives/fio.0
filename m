Return-Path: <prvs=76726b587=Bart.VanAssche@wdc.com>
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Zoned block device support for fio
Date: Fri, 24 Aug 2018 16:42:10 +0000
Message-ID: <480f2de2cfe43c779304f7b470f84ed3f9903713.camel@wdc.com>
References: <a1373211271aee157884ec6dea024ecc2c17331d.camel@wdc.com>
	 <be10a7d0-2d90-9381-4d05-6c4c4b81d461@kernel.dk>
In-Reply-To: <be10a7d0-2d90-9381-4d05-6c4c4b81d461@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="utf-7"
Content-ID: <1487784A2F31C749AD0452AAE4E2C129@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jason Jorgensen <jason.jorgensen@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "phillip.a.chen@seagate.com" <phillip.a.chen@seagate.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-ID: <fio@vger.kernel.org>

On Fri, 2018-08-24 at 07:48 -0600, Jens Axboe wrote:
+AD4- I think this is starting to look good. For the filesetup.c changes, I=
 think
+AD4- that this:
+AD4-=20
+AD4- +-       if (o-+AD4-zone+AF8-mode +AD0APQ- ZONE+AF8-MODE+AF8-NONE +AC=
YAJg- o-+AD4-zone+AF8-size)
+AD4- +-               o-+AD4-zone+AF8-mode +AD0- ZONE+AF8-MODE+AF8-STRIDED=
+ADs-
+AD4-=20
+AD4- belongs in fixup+AF8-options().

Hello Jens,

Thanks for having taken a look. That change has been made in the patches I
just posted on the fio mailing list.

+AD4- zbd+AF8-init() should not be something that
+AD4- is unconditionally called. Only do it if ZONE+AF8-MODE+AF8-ZBD is set=
 and make
+AD4- that explicit.

There is a test in the zbd+AF8-init() code that makes fio report an error
message if --zonemode+AD0-zbd has not been specified for zoned block device=
s:

	if (td-+AD4-o.zone+AF8-mode +ACEAPQ- ZONE+AF8-MODE+AF8-ZBD) +AHs-
 		for+AF8-each+AF8-file(td, f, i) +AHs-
			if (get+AF8-zbd+AF8-model(f-+AD4-file+AF8-name) +ACEAPQ- ZBD+AF8-DM+AF8-=
HOST+AF8-MANAGED)
				continue+ADs-
			log+AF8-err(+ACIAJQ-s: Using --zonemode+AD0-zbd is mandatory for host-ma=
naged drives+AFw-n+AFw-n+ACI-,
				f-+AD4-file+AF8-name)+ADs-
			return 1+ADs-
		+AH0-
	+AH0-

I think that error message is very helpful for people who run fio for the
first time against a zoned block device so I would like to keep that error
message. However, I'm not sure where you would like me to move that code if
zbd+AF8-init() is only called for --zonemode+AD0-zbd?

+AD4- Also kill zbd querying in zbd+AF8-init() if we haven't asked for it.

Can you clarify this? parse+AF8-zone+AF8-info() and read+AF8-zone+AF8-info(=
) are only called
if --zonemode+AD0-zbd has been specified. The only new query that is trigge=
red
from zbd+AF8-init() for regular block devices is get+AF8-zbd+AF8-model(). T=
hat function
reads /sys/dev/block/.../queue/zoned but does not try to perform any ioctls
that are specific to zoned block devices.

Thanks,

Bart.


