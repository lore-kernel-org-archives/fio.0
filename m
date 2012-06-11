Return-Path: <gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
From: =?iso-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Date: Mon, 11 Jun 2012 01:00:59 -0600
Subject: Re: Error running Fio SSD example
Message-ID: <4FD597AB.7060007@thomas-krenn.com>
References: <4FC8942A.6090805@thomas-krenn.com>
 <4FD1F462.4070404@fusionio.com> <4FD23443.6020705@thomas-krenn.com>
 <4FD24807.8080700@fusionio.com>
In-Reply-To: <4FD24807.8080700@fusionio.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_4FD597AB7060007thomaskrenncom_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_000_4FD597AB7060007thomaskrenncom_
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am 2012-06-08 20:44, schrieb Jens Axboe:

On 2012-06-08 19:20, Georg Sch=F6nberger wrote:


Am 2012-06-08 14:47, schrieb Jens Axboe:


On 06/01/2012 12:06 PM, Georg Sch=F6nberger wrote:


Hello again,

I am having some troubles with running the fio example "ssd-test". I
changed the global section to decrease the size:
[global]
bs=3D4k
ioengine=3Dlibaio
iodepth=3D4
size=3D100M
direct=3D1
runtime=3D60
filename=3Dssd.test.file

If I am running Fio I get the following error:
----------------------------------------
fio.git/examples$ fio ssd-test
seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodepth=
=3D4
rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iod=
epth=3D4
seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodept=
h=3D4
rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, i=
odepth=3D4
fio-2.0.8
Starting 4 processes
fio: pid=3D17997, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.file)=
,
error=3DInvalid argument
fio: pid=3D17998, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.file)=
,
error=3DInvalid argument
fio: pid=3D17999, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.file)=
,
error=3DInvalid argument
fio: pid=3D18000, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.file)=
,
error=3DInvalid argument


Looks like the file system hosting the test file does not support
O_DIRECT.



The file system is ext4.
Kernel Version 3.2.0-24-generic



And you aren't running the job file in some other location? ext4 would
definitely work. Please do:

# strace -o strace.out -f fio ssd-test

and send me strace.out (gzip'ed). Also include a pwd from where you are
running it, and output of the 'mount' command.



Here is the solution to my problem (answered from Jens Axboe):
ecryptfs does not support O_DIRECT IO. So that was the explanation for the =
problem.

Also a patch so that FIO gives some further information now:
Sure, I think it'd be a good idea if fio also complains that this is the li=
kely explanation. Fio does this if the first IO errors, but it doesn't catc=
h cases where O_DIRECT simply isn't supported. Can you try this patch, see =
if it complains as it should?

The patch has already been commited (also from Jens):

diff --git a/filesetup.c b/filesetup.c
index a1ad026..b1f73f7 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -526,6 +526,11 @@ open_again:

                snprintf(buf, sizeof(buf) - 1, "open(%s)", f->file_name);

+               if (__e =3D=3D EINVAL && (flags & OS_O_DIRECT)) {
+                       log_err("fio: looks like your file system does not =
" \
+                               "support direct=3D1/buffered=3D0\n");
+               }
+
                td_verror(td, __e, buf);
        }




--_000_4FD597AB7060007thomaskrenncom_
Content-Type: text/html; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

<html>
  <head>
    <meta content=3D"text/html; charset=3DISO-8859-15"
      http-equiv=3D"Content-Type">
  </head>
  <body bgcolor=3D"#FFFFFF" text=3D"#000000">
    Am 2012-06-08 20:44, schrieb Jens Axboe:
    <blockquote cite=3D"mid:4FD24807.8080700@fusionio.com" type=3D"cite">
      <pre wrap=3D"">On 2012-06-08 19:20, Georg Sch=F6nberger wrote:
</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"">Am 2012-06-08 14:47, schrieb Jens Axboe:
</pre>
        <blockquote type=3D"cite">
          <pre wrap=3D"">On 06/01/2012 12:06 PM, Georg Sch=F6nberger wrote:
</pre>
          <blockquote type=3D"cite">
            <pre wrap=3D"">Hello again,

I am having some troubles with running the fio example "ssd-test". I
changed the global section to decrease the size:
[global]
bs=3D4k
ioengine=3Dlibaio
iodepth=3D4
size=3D100M
direct=3D1
runtime=3D60
filename=3Dssd.test.file

If I am running Fio I get the following error:
----------------------------------------
fio.git/examples$ fio ssd-test
seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodepth=
=3D4
rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iod=
epth=3D4
seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodept=
h=3D4
rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, i=
odepth=3D4
fio-2.0.8
Starting 4 processes
fio: pid=3D17997, err=3D22/<a class=3D"moz-txt-link-freetext" href=3D"file:=
filesetup.c:529">file:filesetup.c:529</a>, func=3Dopen(ssd.test.file),
error=3DInvalid argument
fio: pid=3D17998, err=3D22/<a class=3D"moz-txt-link-freetext" href=3D"file:=
filesetup.c:529">file:filesetup.c:529</a>, func=3Dopen(ssd.test.file),
error=3DInvalid argument
fio: pid=3D17999, err=3D22/<a class=3D"moz-txt-link-freetext" href=3D"file:=
filesetup.c:529">file:filesetup.c:529</a>, func=3Dopen(ssd.test.file),
error=3DInvalid argument
fio: pid=3D18000, err=3D22/<a class=3D"moz-txt-link-freetext" href=3D"file:=
filesetup.c:529">file:filesetup.c:529</a>, func=3Dopen(ssd.test.file),
error=3DInvalid argument
</pre>
          </blockquote>
          <pre wrap=3D"">Looks like the file system hosting the test file d=
oes not support
O_DIRECT.

</pre>
        </blockquote>
        <pre wrap=3D"">The file system is ext4.
Kernel Version 3.2.0-24-generic
</pre>
      </blockquote>
      <pre wrap=3D"">
And you aren't running the job file in some other location? ext4 would
definitely work. Please do:

# strace -o strace.out -f fio ssd-test

and send me strace.out (gzip'ed). Also include a pwd from where you are
running it, and output of the 'mount' command.

</pre>
    </blockquote>
    Here is the solution to my problem (answered from Jens Axboe):<br>
    <i>ecryptfs does not support O_DIRECT IO. So that was the
      explanation for
      the problem.</i><br>
    <br>
    Also a patch so that FIO gives some further information now:<br>
    <i>Sure, I think it'd be a good idea if fio also complains that this
      is the
      likely explanation. Fio does this if the first IO errors, but it
      doesn't
      catch cases where O_DIRECT simply isn't supported.
      Can you try this patch, see if it complains as it should?</i><br>
    <br>
    The patch has already been commited (also from Jens):<br>
    <pre wrap=3D"">diff --git a/filesetup.c b/filesetup.c
index a1ad026..b1f73f7 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -526,6 +526,11 @@ open_again:
=20
 		snprintf(buf, sizeof(buf) - 1, "open(%s)", f-&gt;file_name);
=20
+		if (__e =3D=3D EINVAL &amp;&amp; (flags &amp; OS_O_DIRECT)) {
+			log_err("fio: looks like your file system does not " \
+				"support direct=3D1/buffered=3D0\n");
+		}
+
 		td_verror(td, __e, buf);
 	}</pre>
    <br>
    <br>
    <br>
  </body>
</html>

--_000_4FD597AB7060007thomaskrenncom_--


