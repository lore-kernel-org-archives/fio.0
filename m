Return-Path: <ms@teamix.de>
MIME-Version: 1.0
From: Martin Steigerwald <ms@teamix.de>
Date: Mon, 7 May 2012 08:18:26 -0600
Subject: [PATCH 3/3] Fix hyphen as minus sign errors by escaping minus signs.
Message-ID: 
 <7110e1085846633e24c173aa53932ae8ba1f718d.1336399881.git.ms@teamix.de>
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

---
 fio.1 |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fio.1 b/fio.1
index 23650ce..5b61e43 100644
--- a/fio.1
+++ b/fio.1
@@ -1322,42 +1322,42 @@ for TCP/IP v4, 'ip6' for TCP/IP v6, or 'sock' for a=
 local unix domain
 socket. 'hostname' is either a hostname or IP address, and 'port' is the p=
ort to
 listen to (only valid for TCP/IP, not a local socket). Some examples:
=20
-1) fio --server
+1) fio \-\-server
=20
    Start a fio server, listening on all interfaces on the default port (87=
65).
=20
-2) fio --server=3Dip:hostname,4444
+2) fio \-\-server=3Dip:hostname,4444
=20
    Start a fio server, listening on IP belonging to hostname and on port 4=
444.
=20
-3) fio --server=3Dip6:::1,4444
+3) fio \-\-server=3Dip6:::1,4444
=20
    Start a fio server, listening on IPv6 localhost ::1 and on port 4444.
=20
-4) fio --server=3D,4444
+4) fio \-\-server=3D,4444
=20
    Start a fio server, listening on all interfaces on port 4444.
=20
-5) fio --server=3D1.2.3.4
+5) fio \-\-server=3D1.2.3.4
=20
    Start a fio server, listening on IP 1.2.3.4 on the default port.
=20
-6) fio --server=3Dsock:/tmp/fio.sock
+6) fio \-\-server=3Dsock:/tmp/fio.sock
=20
    Start a fio server, listening on the local socket /tmp/fio.sock.
=20
 When a server is running, you can connect to it from a client. The client
 is run with:
=20
-fio --local-args --client=3Dserver --remote-args <job file(s)>
+fio \-\-local-args \-\-client=3Dserver \-\-remote-args <job file(s)>
=20
-where --local-args are arguments that are local to the client where it is
-running, 'server' is the connect string, and --remote-args and <job file(s=
)>
+where \-\-local-args are arguments that are local to the client where it i=
s
+running, 'server' is the connect string, and \-\-remote-args and <job file=
(s)>
 are sent to the server. The 'server' string follows the same format as it
 does on the server side, to allow IP/hostname/socket and port strings.
 You can connect to multiple clients as well, to do that you could run:
=20
-fio --client=3Dserver2 --client=3Dserver2 <job file(s)>
+fio \-\-client=3Dserver2 \-\-client=3Dserver2 <job file(s)>
 .SH AUTHORS
=20
 .B fio
--=20
1.7.10


