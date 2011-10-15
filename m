Return-Path: <bruce@cran.org.uk>
Subject: Re: Fio 2.0 coming (was "Re: Recent changes")
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=iso-8859-1
From: Bruce Cran <bruce@cran.org.uk>
In-Reply-To: <4E9993CE.7070609@kernel.dk>
Date: Sat, 15 Oct 2011 15:11:14 +0100
Content-Transfer-Encoding: 7bit
Message-Id: <A0132717-A0FA-4A19-8210-509150D7855A@cran.org.uk>
References: <20111014040002.95902484001@kernel.dk> <4E97D492.8080305@kernel.dk> <DA4ADF0A-3461-46AD-B5B7-E24CBAF4D1E9@cran.org.uk> <4E993F9B.2030705@kernel.dk> <4E9942D3.5050702@kernel.dk> <4E998031.7060807@kernel.dk> <07F638D7-A704-409B-B58F-9DEC711A84F3@cran.org.uk> <4E9991B7.4050408@kernel.dk> <4E9993CE.7070609@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 15 Oct 2011, at 15:08, Jens Axboe wrote:

> Added attempt at failing naturally when that happens, does it reproduce
> now?

It doesn't crash now - it prints a warning and exits normally:

fio: fragment opcode mismatch (6 != 7)
client: host=localhost disconnected

-- 
Bruce Cran


