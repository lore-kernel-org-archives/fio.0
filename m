Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: Recent changes (master)
Date: Thu, 9 May 2019 15:47:06 +0000
Message-ID: <AT5PR8401MB1169B5D8881E1D2E3D11EC4DAB330@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190509120003.26BCA2C098E@kernel.dk>
In-Reply-To: <20190509120003.26BCA2C098E@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
> Of Jens Axboe
> Sent: Thursday, May 09, 2019 7:00 AM
> To: fio@vger.kernel.org
> Subject: Recent changes (master)
...
> -					printf("Your filesystem doesn't
> support poll\n");
> +					printf("Your filesystem/device
> doesn't "
> +						"support polled IO\n");

Can you keep that string on one line so it is grep-able?



