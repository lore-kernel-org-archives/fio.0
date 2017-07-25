Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/4] HOWTO: add missing [netsplice] for ioengine specific options
Date: Tue, 25 Jul 2017 22:05:43 +0300
Message-Id: <20170725190544.66919-4-tkusumi@tuxera.com>
In-Reply-To: <20170725190544.66919-1-tkusumi@tuxera.com>
References: <20170725190544.66919-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These seem to be supported whether a socket is read/written by
send/recv or splice.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 8 ++++----
 fio.1 | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/HOWTO b/HOWTO
index 5a9cda5..2fa8fc2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1889,13 +1889,13 @@ caveat that when used on the command line, they must come after the
 	hostname if the job is a TCP listener or UDP reader. For unix sockets, the
 	normal filename option should be used and the port is invalid.
 
-.. option:: listen : [net]
+.. option:: listen : [netsplice] [net]
 
 	For TCP network connections, tell fio to listen for incoming connections
 	rather than initiating an outgoing connection. The :option:`hostname` must
 	be omitted if this option is used.
 
-.. option:: pingpong : [net]
+.. option:: pingpong : [netsplice] [net]
 
 	Normally a network writer will just continue writing data, and a network
 	reader will just consume packages. If ``pingpong=1`` is set, a writer will
@@ -1907,11 +1907,11 @@ caveat that when used on the command line, they must come after the
 	``pingpong=1`` should only be set for a single reader when multiple readers
 	are listening to the same address.
 
-.. option:: window_size : [net]
+.. option:: window_size : [netsplice] [net]
 
 	Set the desired socket buffer size for the connection.
 
-.. option:: mss : [net]
+.. option:: mss : [netsplice] [net]
 
 	Set the TCP maximum segment size (TCP_MAXSEG).
 
diff --git a/fio.1 b/fio.1
index 84bd466..768b209 100644
--- a/fio.1
+++ b/fio.1
@@ -2069,7 +2069,7 @@ For TCP network connections, tell fio to listen for incoming
 connections rather than initiating an outgoing connection. The
 hostname must be omitted if this option is used.
 .TP
-.BI (net)pingpong \fR=\fPbool
+.BI (net,netsplice)pingpong \fR=\fPbool
 Normally a network writer will just continue writing data, and a network reader
 will just consume packets. If pingpong=1 is set, a writer will send its normal
 payload to the reader, then wait for the reader to send the same payload back.
@@ -2079,10 +2079,10 @@ completion latency measures how long it took for the other end to receive and
 send back. For UDP multicast traffic pingpong=1 should only be set for a single
 reader when multiple readers are listening to the same address.
 .TP
-.BI (net)window_size \fR=\fPint
+.BI (net,netsplice)window_size \fR=\fPint
 Set the desired socket buffer size for the connection.
 .TP
-.BI (net)mss \fR=\fPint
+.BI (net,netsplice)mss \fR=\fPint
 Set the TCP maximum segment size (TCP_MAXSEG).
 .TP
 .BI (e4defrag)donorname \fR=\fPstr
-- 
2.9.4


