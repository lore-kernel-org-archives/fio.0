Return-Path: <ms@teamix.de>
MIME-Version: 1.0
From: Martin Steigerwald <ms@teamix.de>
Date: Mon, 7 May 2012 08:18:25 -0600
Subject: [PATCH 2/3] Fix manpage error warning: macro `hostname'' not
 defined.
Message-ID: 
 <b3065c97eb6fe0d0349d86a8d1bb64887164fc87.1336399881.git.ms@teamix.de>
References: 
 <5df008af9a2c71c1b680c554a7c8c0ab6041b9f7.1336399881.git.ms@teamix.de>
In-Reply-To: 
 <5df008af9a2c71c1b680c554a7c8c0ab6041b9f7.1336399881.git.ms@teamix.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>, Martin Steigerwald <ms@teamix.de>
List-ID: <fio@vger.kernel.org>

Fix manpage error warning: macro `hostname'' not defined by using
different line wrapping.
---
 fio.1 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fio.1 b/fio.1
index 4e626b0..23650ce 100644
--- a/fio.1
+++ b/fio.1
@@ -1318,8 +1318,8 @@ To start the server, you would do:
=20
 on that machine, where args defines what fio listens to. The arguments
 are of the form 'type:hostname or IP:port'. 'type' is either 'ip' (or ip4)
-for TCP/IP v4, 'ip6' for TCP/IP v6, or 'sock' for a local unix domain sock=
et.
-'hostname' is either a hostname or IP address, and 'port' is the port to
+for TCP/IP v4, 'ip6' for TCP/IP v6, or 'sock' for a local unix domain
+socket. 'hostname' is either a hostname or IP address, and 'port' is the p=
ort to
 listen to (only valid for TCP/IP, not a local socket). Some examples:
=20
 1) fio --server
--=20
1.7.10


