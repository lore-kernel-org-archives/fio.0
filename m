Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <d9332e23-633e-c4c0-381b-b2fcbd983e15@bsdio.com>
 <87ec264a-c0cd-2868-4173-f7d52297e7d5@gmail.com> <CS1PR8401MB1237B6211F30F9C8C1450CE1ABB10@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
 <CALjAwxgPF_oHQgDMr+v8y6r1AKbMUf9PKLxdctCugY4CHPy27w@mail.gmail.com> <CS1PR8401MB1237D43565B8F691EA902AC6AB8F0@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <CS1PR8401MB1237D43565B8F691EA902AC6AB8F0@CS1PR8401MB1237.NAMPRD84.PROD.OUTLOOK.COM>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 30 May 2020 04:36:27 +0100
Message-ID: <CALjAwxhZN9hOONERh0N2=mFCkm7we01qB6X8x12yQG_h3JGMQg@mail.gmail.com>
Subject: Re: Python scripts - /usr/bin/env python3 vs python vs python2.7
Content-Type: text/plain; charset="UTF-8"
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Vincent Fu <vincentfu@gmail.com>, Rebecca Cran <rebecca@bsdio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Fri, 29 May 2020 at 21:42, Elliott, Robert (Servers) <elliott@hpe.com> wrote:
>
> > -----Original Message-----
> > From: Sitsofe Wheeler <sitsofe@gmail.com>
> > Sent: Thursday, May 28, 2020 3:20 AM
> > To: Elliott, Robert (Servers) <elliott@hpe.com>
> > Cc: Vincent Fu <vincentfu@gmail.com>; Rebecca Cran
> > <rebecca@bsdio.com>; fio@vger.kernel.org; Jens Axboe
> > <axboe@kernel.dk>
> > Subject: Re: Python scripts - /usr/bin/env python3 vs python vs
> > python2.7
> >
> > > I have been using python a lot recently and also noticed that the
> > > /usr/bin/env format is the preferred approach; it works best across
> > > linux distros, local installs, and is even recognized by Python in
> > > Windows.
> >
> > I'm guessing that's only in git for windows style shells? Surely
> > native Windows will just look at the extension and then look in the
> > registry?
>
> With Python 3.8 installed (as "python", which is how the upstream installer
> names it), this is what it does in PowerShell:
>
> PS D:\> type testshe.py                                                                                              #!/usr/bin/env python
> print("hello")
>
> PS D:\> type testshe2.py                                                                                             #!/usr/bin/env python2
> print("hello")
>
> PS D:\> type testshe3.py                                                                                             #!/usr/bin/env python3
> print("hello")
>
> PS D:\> type testshe310.py                                                                                           #!/usr/bin/env python3.10
> print("hello")
>
> PS D:\> ./testshe.py; ./testshe2.py; ./testshe3.py; ./testshe310.py
> hello
> Requested Python version (2) is not installed
> hello
> Requested Python version (3.10) is not installed
>
> PS D:\> python ./testshe.py; python ./testshe2.py; python ./testshe3.py; python ./testshe310.py
> hello
> hello
> hello
> hello
>
> In other words, it checks the shebang version if invoked indirectly,
> but ignores it the python script filename is an argument.

Wow - TIL... It looks like this support is down to the Python launcher
for Windows (https://docs.python.org/3/using/windows.html#shebang-lines
). Thanks for taking the time to correct me Elliot!

-- 
Sitsofe | http://sucs.org/~sits/

