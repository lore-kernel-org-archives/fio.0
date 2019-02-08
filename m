Return-Path: <prvs=9358eb757=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] client/server: inflate error handling
Date: Fri, 8 Feb 2019 21:43:32 +0000
Message-ID: 
 <MWHPR04MB03208D586D958B32CAC0AD678F690@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

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
_END will be checked for later.=20

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



