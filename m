Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42835 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbfARUF4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Jan 2019 15:05:56 -0500
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: client/server: inflate and deflate error handling
Date: Fri, 18 Jan 2019 20:05:48 +0000
Message-ID: <MWHPR04MB03200FF19D62294AD70764798F9C0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

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


I have tried a few different patches here, but am seeing new issues.  First=
 I attempted to patch all cases of inflate/deflate error checking (patch 1)=
, but got some hangs.  Finally I tried patching one small case (patch 2) bu=
t got:

err=3D22/file:ioengines.c:443, func=3Dio commit, error=3DInvalid argument

Any thoughts on how the errors are persisting or where in the decompression=
 process the flow is broken?  Unfortunately getting the issue to repeat req=
uires a few hours (seemingly more hours with patch 2 applied), so any ideas=
 to make a targeted test for decompressing specific size buffers may also b=
e helpful.  Thanks.

Regards,
Jeff



[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DPATCH 1=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D]
diff --git a/client.c b/client.c
index 480425f..bf8bc4c 100644
--- a/client.c
+++ b/client.c
@@ -1598,10 +1598,13 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struc=
t fio_net_cmd *cmd,
 		err =3D inflate(&stream, Z_NO_FLUSH);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (err < 0) {
-			log_err("fio: inflate error %d\n", err);
-			free(ret);
-			ret =3D NULL;
-			goto err;
+			/* Z_STREAM_ERROR and Z_BUF_ERROR can safely be ignored */
+			if ((err !=3D Z_STREAM_ERROR) && (err !=3D Z_BUF_ERROR)) {
+				log_err("fio: inflate error %d\n", err);
+				free(ret);
+				ret =3D NULL;
+				goto err;
+			}
 		}
=20
 		this_len =3D this_chunk - stream.avail_out;
diff --git a/iolog.c b/iolog.c
index b72dcf9..6986bff 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1027,9 +1027,12 @@ static size_t inflate_chunk(struct iolog_compress *i=
c, int gz_hdr, FILE *f,
=20
 		err =3D inflate(stream, Z_NO_FLUSH);
 		if (err < 0) {
-			log_err("fio: failed inflating log: %d\n", err);
-			iter->err =3D err;
-			break;
+            /* Z_STREAM_ERROR and Z_BUF_ERROR can safely be ignored */
+			if ((err !=3D Z_STREAM_ERROR) && (err !=3D Z_BUF_ERROR)) {
+			    log_err("fio: failed inflating log: %d\n", err);
+			    iter->err =3D err;
+			    break;
+            }
 		}
=20
 		iter->buf_used +=3D this_out - stream->avail_out;
@@ -1335,9 +1338,12 @@ static int gz_work(struct iolog_flush_data *data)
 		stream.next_out =3D c->buf;
 		ret =3D deflate(&stream, Z_NO_FLUSH);
 		if (ret < 0) {
-			log_err("fio: deflate log (%d)\n", ret);
-			free_chunk(c);
-			goto err;
+            /* Z_STREAM_ERROR and Z_BUF_ERROR can safely be ignored */
+			if ((ret !=3D Z_STREAM_ERROR) && (ret !=3D Z_BUF_ERROR)) {
+			    log_err("fio: deflate log (%d)\n", ret);
+			    free_chunk(c);
+			    goto err;
+            }
 		}
=20
 		c->len =3D GZ_CHUNK - stream.avail_out;
diff --git a/server.c b/server.c
index 2a33770..d64e5f1 100644
--- a/server.c
+++ b/server.c
@@ -1739,8 +1739,11 @@ static int __deflate_pdu_buffer(void *next_in, unsig=
ned int next_sz, void **out_
 		ret =3D deflate(stream, Z_BLOCK);
=20
 		if (ret < 0) {
-			free(*out_pdu);
-			return 1;
+            /* Z_STREAM_ERROR and Z_BUF_ERROR can safely be ignored */
+			if ((ret !=3D Z_STREAM_ERROR) && (ret !=3D Z_BUF_ERROR)) {
+			    free(*out_pdu);
+			    return 1;
+            }
 		}
 	} while (stream->avail_in);
=20
@@ -1823,8 +1826,11 @@ static int __fio_append_iolog_gz(struct sk_entry *fi=
rst, struct io_log *log,
 		ret =3D deflate(stream, Z_BLOCK);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (ret < 0) {
-			free(out_pdu);
-			return 1;
+            /* Z_STREAM_ERROR and Z_BUF_ERROR can safely be ignored */
+			if ((ret !=3D Z_STREAM_ERROR) && (ret !=3D Z_BUF_ERROR)) {
+			    free(out_pdu);
+			    return 1;
+            }
 		}
=20
 		this_len =3D FIO_SERVER_MAX_FRAGMENT_PDU - stream->avail_out;



[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3DPATCH 2=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D]
diff --git a/client.c b/client.c
index 480425f..522edbf 100644
--- a/client.c
+++ b/client.c
@@ -1598,7 +1598,9 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct =
fio_net_cmd *cmd,
 		err =3D inflate(&stream, Z_NO_FLUSH);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (err < 0) {
-			log_err("fio: inflate error %d\n", err);
+			/* Z_STREAM_ERROR and Z_BUF_ERROR can safely be ignored */
+			if ((err =3D=3D Z_STREAM_ERROR) || (err =3D=3D Z_BUF_ERROR))
+				break;
 			free(ret);
 			ret =3D NULL;
 			goto err;



