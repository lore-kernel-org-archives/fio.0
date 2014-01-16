Return-Path: <castor@egocast.org>
MIME-Version: 1.0
In-Reply-To: <20140111050002.05C7E231C8@kernel.dk>
References: <20140111050002.05C7E231C8@kernel.dk>
Date: Thu, 16 Jan 2014 12:07:19 -0800
Message-ID: <CALKLVu+yF1smDDX__NbszKpCrfNTHStArMBWD6j8HL5hwZ0q0Q@mail.gmail.com>
Subject: Re: Recent changes (master)
From: Castor Fu <castor@egocast.org>
Content-Type: multipart/alternative; boundary="f46d0421a6390ca23804f01bf95a"
To: Jens Axboe <jaxboe@fusionio.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--f46d0421a6390ca23804f01bf95a
Content-Type: text/plain; charset="ISO-8859-1"

On Fri, Jan 10, 2014 at 9:00 PM, Jens Axboe <jaxboe@fusionio.com> wrote:

>
>
> Jens Axboe (1):
>       Add option to manually seed the random generators
>

Hi Jens:  Have you seen the work on counter-based random number generators?
 They might be applicable here.

The basic idea is that if you encrypt the value of a a counter, you can get
usefully random
bits. You can do something like use some of the bits for thread number,
file number, etc.
and be able to generate the expected state without cycling through the RNG.

See for example:

http://www.deshawresearch.com/resources_random123.html

--f46d0421a6390ca23804f01bf95a
Content-Type: text/html; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1"><div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gm=
ail_quote">On Fri, Jan 10, 2014 at 9:00 PM, Jens Axboe <span dir=3D"ltr">&l=
t;<a href=3D"mailto:jaxboe@fusionio.com" target=3D"_blank">jaxboe@fusionio.=
com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><br>
<br>
Jens Axboe (1):<br>
&nbsp; &nbsp; &nbsp; Add option to manually seed the random generators<br><=
/blockquote><div><br></div><div>Hi Jens: &nbsp;Have you seen the work on co=
unter-based random number generators? &nbsp;They might be applicable here.<=
/div><div><br></div>
<div>The basic idea is that if you encrypt the value of a a counter, you ca=
n get usefully random</div><div>bits. You can do something like use some of=
 the bits for thread number, file number, etc.<br></div><div>and be able to=
 generate the expected state without cycling through the RNG.</div>
<div><br></div><div>See for example:</div><div><br></div><div><a href=3D"ht=
tp://www.deshawresearch.com/resources_random123.html">http://www.deshawrese=
arch.com/resources_random123.html</a><br></div></div></div></div>

--f46d0421a6390ca23804f01bf95a--


