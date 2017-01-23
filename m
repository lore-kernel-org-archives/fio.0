Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <eee7c54a-2357-d437-1bbc-df0c467fe7e5@kernel.dk>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
 <1485184391-11036-4-git-send-email-tkusumi@tuxera.com> <CANvN+e=SsCxGCcMNktU88+uSS5_TrZ+jNG1K+gLcgS5vH1ZDDA@mail.gmail.com>
 <eee7c54a-2357-d437-1bbc-df0c467fe7e5@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 23 Jan 2017 21:08:12 +0300
Message-ID: <CANvN+ekVrMHtHDLyOCjBaThpxY-61rwe8RfZ51kCDaX_1GXahw@mail.gmail.com>
Subject: Re: [PATCH 4/8] Remove unused io_u's priv union field
Content-Type: multipart/alternative; boundary=94eb2c115a9e05df2c0546c6e26d
To: Jens Axboe <axboe@kernel.dk>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>, fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

--94eb2c115a9e05df2c0546c6e26d
Content-Type: text/plain; charset=UTF-8

On Jan 23, 2017 21:01, "Jens Axboe" <axboe@kernel.dk> wrote:

On 01/23/2017 09:06 AM, Andrey Kuzmin wrote:
> This may break some I/O engines.

Are you using it? I'm happy to revert that change, it's not like
it's gaining us back some memory. It is annoying to have no in-tree
users of a "feature", though.



That's likely my bad as, from my (now apparently wrong) recollection, some
in-tree engines were utilizing it. I'm fine with the removal otherwise,
although it's a nice generic place-holder that avoids casting.

Regards,
Andfey


--
Jens Axboe

--94eb2c115a9e05df2c0546c6e26d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Jan 23, 2017 21:01, &quot;Jens Axboe&quot; &lt;<a href=3D"mail=
to:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br type=3D"attribution">=
<blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex"><div class=3D"quoted-text">On 01/23/2017 09:06 AM,=
 Andrey Kuzmin wrote:<br>
&gt; This may break some I/O engines.<br>
<br>
</div>Are you using it? I&#39;m happy to revert that change, it&#39;s not l=
ike<br>
it&#39;s gaining us back some memory. It is annoying to have no in-tree<br>
users of a &quot;feature&quot;, though.<br></blockquote></div></div></div><=
div dir=3D"auto"><br></div><div dir=3D"auto"><br></div><div dir=3D"auto">Th=
at&#39;s likely my bad as, from my (now apparently wrong) recollection, som=
e in-tree engines were utilizing it. I&#39;m fine with the removal otherwis=
e, although it&#39;s a nice generic place-holder that avoids casting.</div>=
<div dir=3D"auto"><br></div><div dir=3D"auto">Regards,</div><div dir=3D"aut=
o">Andfey</div><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"=
gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></blockquote></div><br></div></div></div>

--94eb2c115a9e05df2c0546c6e26d--

