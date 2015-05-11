Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU406-EAS199DBAAA5C83E547D2C0EBFE0DB0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU406-EAS203C4EE266D87AD0F72049E0DB0@phx.gbl> <5550D6D3.9050803@kernel.dk>
In-Reply-To: <5550D6D3.9050803@kernel.dk>
Subject: RE: Why Seperate Log Files?
Date: Mon, 11 May 2015 15:28:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
To: 'Jens Axboe' <axboe@kernel.dk>, 'Andrey Kuzmin' <andrey.v.kuzmin@gmail.com>
Cc: 'Sitsofe Wheeler' <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Well, I can honestly admit that I deserved that. Sorry, I had wrote that =
after having stressed out for like 5 hours trying to get the outputs =
correct using a variety of commands with the new version. It =
wasn=E2=80=99t until I switched back to the old version that I realized =
somewhere along the line the output format had changed. I will re-submit =
this with some context.=20

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Monday, May 11, 2015 11:21 AM
To: Jon Tango; 'Andrey Kuzmin'
Cc: 'Sitsofe Wheeler'; fio@vger.kernel.org
Subject: Re: Why Seperate Log Files?

On 05/10/2015 09:36 PM, Jon Tango wrote:
> When I use fio in 2.1.8 the write_iops_log command creates a singular =
log file, even with 8 workers. With fio in the latest versions, however, =
it creates eight separate log files. Is there a way to get fio to =
generate a log file for all 8 workers, instead of 8 separate files? That =
is untenable. I had to go back to 2.1.8 to get a useable output. It's =
not like the data outputs are very friendly anyway, but with one file at =
least that data can easily be parsed and worked with. With a different =
file for each worker it is just ridiculous.
> How do we get one output for all workers?
> It would also be nice if we could just get one output with all of the=20
> numbers for the different workers combined, but that may be asking a=20
> bit much. Just getting them all in a workable file would be nice :)

Lets back this up a bit. Your bug reporting _sucks_. Constructive =
criticism - look it up. You were even lazy enough to just reply to an =
old, totally unrelated email, instead of starting a new thread.

So lets try this again. I'll even offer you some free hints. Find out =
where the change happened, see if there's reasoning there. If not, =
suggest a way to improve the situation. Or even just, constructively, =
suggest why the current behavior is a problem and offer your opinion on =
how it could be improved to make your life easier. Nobody on this list =
owes you anything, you need to earn it.

--
Jens Axboe


