Return-Path: <gurvindersinghdahiya@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5727FBC2.1020000@kernel.dk>
References: <a001b187-7ced-1295-2f6d-80039621aa88@gmail.com>
	<5727FBC2.1020000@kernel.dk>
Date: Tue, 3 May 2016 05:48:27 +0200
Message-ID: <CAK4kHmM_-k6r8+TRDjFDy=uEveEt-g_BbT7GRntz8hawBbvuSQ@mail.gmail.com>
Subject: Re: client/server test to write to single file from all clients
From: Gurvinder Singh <gurvindersinghdahiya@gmail.com>
Content-Type: multipart/alternative; boundary=089e0122978a635d640531e7fb02
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--089e0122978a635d640531e7fb02
Content-Type: text/plain; charset=UTF-8

Thanks Jens for the reply. If FIO supports writing to same file in
client/server mode then what should be filename/filename_pattern should be.
As in currently specifying filename it appends hostname to file name and
thus each client ends up writing to its own file.

- Gurvinder
On May 3, 2016 3:15 AM, "Jens Axboe" <axboe@kernel.dk> wrote:

> On 05/01/2016 01:11 PM, Gurvinder Singh wrote:
>
>> Hi,
>>
>> First of all thanks for such a nice tool to do IO testing. I am
>> wondering if it is possible to test accessing a single file from
>> multiple clients to test distributed file system behavior.
>>
>> The reason for this test is to see if it has different behavior than
>> having numjobs > 1 accessing same file running on same host.
>>
>
> Sure, you can do that. Fio doesn't really care about whether the file is
> shared or not. Obviously some things like verification might not work
> properly, but just reading and writing to a shared file, fio doesn't care
> if it's local or not.
>
>
> --
> Jens Axboe
>
>

--089e0122978a635d640531e7fb02
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Thanks Jens for the reply. If FIO supports writing to same f=
ile in client/server mode then what should be filename/filename_pattern sho=
uld be. As in currently specifying filename it appends hostname to file nam=
e and thus each client ends up writing to its own file.</p>
<p dir=3D"ltr">- Gurvinder</p>
<div class=3D"gmail_quote">On May 3, 2016 3:15 AM, &quot;Jens Axboe&quot; &=
lt;<a href=3D"mailto:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br typ=
e=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">On 05/01/2016 01:11 PM, Gu=
rvinder Singh wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi,<br>
<br>
First of all thanks for such a nice tool to do IO testing. I am<br>
wondering if it is possible to test accessing a single file from<br>
multiple clients to test distributed file system behavior.<br>
<br>
The reason for this test is to see if it has different behavior than<br>
having numjobs &gt; 1 accessing same file running on same host.<br>
</blockquote>
<br>
Sure, you can do that. Fio doesn&#39;t really care about whether the file i=
s shared or not. Obviously some things like verification might not work pro=
perly, but just reading and writing to a shared file, fio doesn&#39;t care =
if it&#39;s local or not.<br>
<br>
<br>
-- <br>
Jens Axboe<br>
<br>
</blockquote></div>

--089e0122978a635d640531e7fb02--

