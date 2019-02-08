Return-Path: <prvs=9358eb757=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] client/server: inflate error handling
Date: Fri, 8 Feb 2019 21:40:55 +0000
Message-ID: 
 <MWHPR04MB0320BE525ACF2346A0D824DB8F690@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_MWHPR04MB0320BE525ACF2346A0D824DB8F690MWHPR04MB0320namp_"
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--_000_MWHPR04MB0320BE525ACF2346A0D824DB8F690MWHPR04MB0320namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Occasionally fio client/server with zlib enabled may report:

fio: inflate error -5
fio: failed decompressing log
fio: failed converting IO log

The error -5 is a Z_BUF_ERROR, and references are available at https://zlib=
.net/zlib_how.html and https://www.zlib.net/manual.html  It seems that when=
 decompressing the buffer, if the buffer chunk is the same size as remainin=
g data in the buffer, the Z_BUF_ERROR can safely be ignored.  So one idea i=
s to ignore the safe errors noting the zlib references:

"inflate() can also return Z_STREAM_ERROR, which should not be possible her=
e, but could be checked for as noted above for def(). Z_BUF_ERROR does not =
need to be checked for here, for the same reasons noted for def(). Z_STREAM=
_END will be checked for later.

            ret =3D inflate(&strm, Z_NO_FLUSH);
            assert(ret !=3D Z_STREAM_ERROR);  /* state not clobbered */
            switch (ret) {
            case Z_NEED_DICT:
                ret =3D Z_DATA_ERROR;     /* and fall through */
            case Z_DATA_ERROR:
            case Z_MEM_ERROR:
                (void)inflateEnd(&strm);
                return ret;
            }

...

The way we tell that deflate() has no more output is by seeing that it did =
not fill the output buffer, leaving avail_out greater than zero. However su=
ppose that deflate() has no more output, but just so happened to exactly fi=
ll the output buffer! avail_out is zero, and we can't tell that deflate() h=
as done all it can. As far as we know, deflate() has more output for us. So=
 we call it again. But now deflate() produces no output at all, and avail_o=
ut remains unchanged as CHUNK. That deflate() call wasn't able to do anythi=
ng, either consume input or produce output, and so it returns Z_BUF_ERROR. =
(See, I told you I'd cover this later.) However this is not a problem at al=
l. Now we finally have the desired indication that deflate() is really done=
, and so we drop out of the inner loop to provide more input to deflate()."



diff --git a/client.c b/client.c
index 480425f..58005a8 100644
--- a/client.c
+++ b/client.c
@@ -1598,6 +1598,9 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct =
fio_net_cmd *cmd,
                               err =3D inflate(&stream, Z_NO_FLUSH);
                               /* may be Z_OK, or Z_STREAM_END */
                               if (err < 0) {
+                                             /* Z_STREAM_ERROR and Z_BUF_E=
RROR can safely be ignored */
+                                             if ((err =3D=3D Z_STREAM_ERRO=
R) || (err =3D=3D Z_BUF_ERROR))
+                                                             break;
                                               log_err("fio: inflate error =
%d\n", err);
                                               free(ret);
                                               ret =3D NULL;



--_000_MWHPR04MB0320BE525ACF2346A0D824DB8F690MWHPR04MB0320namp_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Occasionally fio client/server with zlib enabled may=
 report:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">fio: inflate error -5<o:p></o:p></p>
<p class=3D"MsoNormal">fio: failed decompressing log<o:p></o:p></p>
<p class=3D"MsoNormal">fio: failed converting IO log<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The error -5 is a Z_BUF_ERROR, and references are av=
ailable at https://zlib.net/zlib_how.html and https://www.zlib.net/manual.h=
tml&nbsp; It seems that when decompressing the buffer, if the buffer chunk =
is the same size as remaining data in the
 buffer, the Z_BUF_ERROR can safely be ignored.&nbsp; So one idea is to ign=
ore the safe errors noting the zlib references:<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&quot;inflate() can also return Z_STREAM_ERROR, whic=
h should not be possible here, but could be checked for as noted above for =
def(). Z_BUF_ERROR does not need to be checked for here, for the same reaso=
ns noted for def(). Z_STREAM_END will be
 checked for later. <o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; ret =3D inflate(&amp;strm, Z_NO_FLUSH);<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; assert(ret !=3D Z_STREAM_ERROR);&nbsp; /* state not clobbere=
d */<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; switch (ret) {<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; case Z_NEED_DICT:<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ret =3D Z_DATA_ERROR;&nbsp;&nbsp;&nb=
sp;&nbsp; /* and fall through */<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; case Z_DATA_ERROR:<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; case Z_MEM_ERROR:<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (void)inflateEnd(&amp;strm);<o:p></o=
:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ret;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; }<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">...<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">The way we tell that deflate() has no more output is=
 by seeing that it did not fill the output buffer, leaving avail_out greate=
r than zero. However suppose that deflate() has no more output, but just so=
 happened to exactly fill the output
 buffer! avail_out is zero, and we can't tell that deflate() has done all i=
t can. As far as we know, deflate() has more output for us. So we call it a=
gain. But now deflate() produces no output at all, and avail_out remains un=
changed as CHUNK. That deflate()
 call wasn't able to do anything, either consume input or produce output, a=
nd so it returns Z_BUF_ERROR. (See, I told you I'd cover this later.) Howev=
er this is not a problem at all. Now we finally have the desired indication=
 that deflate() is really done,
 and so we drop out of the inner loop to provide more input to deflate().&q=
uot;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">diff --git a/client.c b/client.c<o:p></o:p></p>
<p class=3D"MsoNormal">index 480425f..58005a8 100644<o:p></o:p></p>
<p class=3D"MsoNormal">--- a/client.c<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&#43;&#43; b/client.c<o:p></o:p></p>
<p class=3D"MsoNormal">@@ -1598,6 &#43;1598,9 @@ static struct cmd_iolog_pd=
u *convert_iolog_gz(struct fio_net_cmd *cmd,<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; err =3D inflate(&amp;=
stream, Z_NO_FLUSH);<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* may be Z_OK, or Z_=
STREAM_END */<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (err &lt; 0) {<o:p=
></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Z_ST=
REAM_ERROR and Z_BUF_ERROR can safely be ignored */<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((er=
r =3D=3D Z_STREAM_ERROR) || (err =3D=3D Z_BUF_ERROR))<o:p></o:p></p>
<p class=3D"MsoNormal">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; break;<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
log_err(&quot;fio: inflate error %d\n&quot;, err);<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
free(ret);<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ret =3D NULL;<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_MWHPR04MB0320BE525ACF2346A0D824DB8F690MWHPR04MB0320namp_--

