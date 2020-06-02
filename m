Return-Path: <martin@lichtvoll.de>
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Python scripts - /usr/bin/env python3 vs python vs python2.7
Date: Tue, 02 Jun 2020 14:31:11 +0200
Message-ID: <3820489.GZLxUJoiUR@merkaba>
In-Reply-To: <CALjAwxgPF_oHQgDMr+v8y6r1AKbMUf9PKLxdctCugY4CHPy27w@mail.gmail.com>
References: <d9332e23-633e-c4c0-381b-b2fcbd983e15@bsdio.com> <CS1PR8401MB1237B6211F30F9C8C1450CE1ABB10@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM> <CALjAwxgPF_oHQgDMr+v8y6r1AKbMUf9PKLxdctCugY4CHPy27w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Vincent Fu <vincentfu@gmail.com>, Rebecca Cran <rebecca@bsdio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi.

Sitsofe Wheeler - 28.05.20, 10:19:48 CEST:
> Given the above, I think the best thing is just to use "#!/usr/bin/env
> python3" everywhere and at least:
>
> - That's nicer to environments that don't have a python interpreter in
> /usr/bin - Nicer if you ever run the scripts in a virtualenv
> - Packagers can fix it up to whatever they like and at least the
> pattern is the same across the board

Okay, also in Debian it means I'd have to patch all the scripts then:

https://www.debian.org/doc/packaging-manuals/python-policy/ch-python.html#s-interpreter_loc

Is there a complete list of Python scripts and especially their status 
in Fio? Are there any left that cannot work with Python 3? The mail by 
Vincent has some hints that there are.

I ask cause at some time in the future Python 2 will be removed from 
Debian. And I'd like to avoid having to patch scripts to support Python 
3 downstream.

fio: Python2 removal in sid/bullseye

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=945641

Thanks,
-- 
Martin



