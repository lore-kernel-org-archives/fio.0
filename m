Return-Path: <axboe@kernel.dk>
Message-ID: <5434A833.1040702@kernel.dk>
Date: Tue, 07 Oct 2014 20:57:55 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk> <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com> <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com> <54346A66.6000509@kernel.dk> <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com> <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com> <54349909.9030701@kernel.dk> <D05A1880.520B9%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D05A1880.520B9%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-07 20:54, Neto, Antonio Jose Rodrigues wrote:
>
>
> On 10/7/14, 9:53 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>
>> On 2014-10-07 19:07, Neto, Antonio Jose Rodrigues wrote:
>>> I found what is happening
>>>
>>> If I use a non absolute path it works: the remote config should be on
>>> the
>>> same directory with fio
>>>
>>>
>>> Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151
>>> --remote-config
>>> conf3
>>>
>>>
>>>
>>> If I specify an absolute path, it does not work
>>>
>>> Nossa Senhora:fio.patch neto$ ./fio --client 10.61.109.151
>>> --remote-config
>>> /root/fio.patch/conf3
>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>> fio=3Dfio-2.1.13-31-g15e3,
>>> flags=3D1
>>>
>>>
>>> Do you think we could fix it to make sure we can use --remote-config
>>> with
>>> an absolute path?
>>
>> That's very odd, there should be nothing special about it. If I do this:
>>
>> axboe@lenny:/home/axboe/git/fio $ stat /root/x.fio
>> stat: cannot stat =EF=BF=BD/root/x.fio=EF=BF=BD: Permission denied
>> $ ./fio --client=3Dlocalhost --remote-config /root/x.fio
>>
>> and run
>>
>> axboe@lenny:/home/axboe/git/fio $ sudo strace -o x -f ./fio --server
>> fio: server listening on 0.0.0.0,8765
>>
>> and then look at the x strace output file, it all looks fine:
>>
>> 28632 recvfrom(4, "\v\0\1\0/root/x.fio", 15, MSG_WAITALL, NULL, NULL) =3D
>> 15
>> 28632 open("/root/x.fio", O_RDONLY)     =3D 5
>>
>> which is all find and dandy. Fio just passes the string of the filename,
>> and the server just does an fopen on that passed in file. So please run
>> the same experiment on your end with an strace of the server and the
>> arguments you used on the client, I'd like to see that.
>>
>> --
>> Jens Axboe
>>
>
> Hi Jens,
>
> This is neto from Brazil
>
> How are you?
>
> It's very strange....
>
> I have applied the patch again... Make clean, make and it's working now :=
-(
>
> On linux it's working
>
> But I applied the patch on my mac, but it's not working
>
> Nossa Senhora:fiop neto$ patch < net-remote-config.patch
> (Stripping trailing CRs from patch.)
> patching file client.c
> (Stripping trailing CRs from patch.)
> patching file client.h
> (Stripping trailing CRs from patch.)
> patching file init.c
> (Stripping trailing CRs from patch.)
> patching file server.c
> (Stripping trailing CRs from patch.)
> patching file server.h
>
>
>
> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
> /root/fiop/model
> Nossa Senhora:fiop neto$
>
>
>
> Could you please make the changes to github and I will download form
> there. Something is not right here with the patch.

Always ensure that you make clean, might be the same on the mac. In any=20
case, it's committed, but it a separate branch. So when pulling, you=20
need to checkout the remote-config branch. Once it's fully done, I will=20
pull it into the master branch.


--=20
Jens Axboe


