Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 8/8] Fix num2str() output when modulo != -1U
Date: Tue, 4 Apr 2017 20:46:46 +0000
Message-ID: <TU4PR84MB01760F9E5030FAF73E7B14BDAB0B0@TU4PR84MB0176.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
 <20170404202218.52260-8-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-8-tkusumi@tuxera.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "kusumi.tomohiro@gmail.com" <kusumi.tomohiro@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of kusumi.tomohiro@gmail.com
> Sent: Tuesday, April 4, 2017 3:22 PM
> Subject: [PATCH 8/8] Fix num2str() output when modulo !=3D -1U
...
> @@ -62,6 +62,9 @@ char *num2str(uint64_t num, int maxlen, int base, int
> pow2, int units)
>  		break;
...
> +	sprintf(fmt, "%%.%df", (int)(maxlen - strlen(tmp) - 1));
> +	sprintf(tmp, fmt, (double)modulo / (double)thousand[!!pow2]);

I suspect one of the goals of that function was to restrict itself
to integer math and avoid invoking the floating point unit (which
might not even exist on some CPUs).


