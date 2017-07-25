Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/4] man: fix broken ioengine specific option format
Date: Tue, 25 Jul 2017 22:05:42 +0300
Message-Id: <20170725190544.66919-3-tkusumi@tuxera.com>
In-Reply-To: <20170725190544.66919-1-tkusumi@tuxera.com>
References: <20170725190544.66919-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The parentheses here are supposed to be for the name of ioengines,
but not for the name of options, according to other correct ones.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fio.1 b/fio.1
index 0badda1..84bd466 100644
--- a/fio.1
+++ b/fio.1
@@ -2069,7 +2069,7 @@ For TCP network connections, tell fio to listen for incoming
 connections rather than initiating an outgoing connection. The
 hostname must be omitted if this option is used.
 .TP
-.BI (net, pingpong) \fR=\fPbool
+.BI (net)pingpong \fR=\fPbool
 Normally a network writer will just continue writing data, and a network reader
 will just consume packets. If pingpong=1 is set, a writer will send its normal
 payload to the reader, then wait for the reader to send the same payload back.
@@ -2079,16 +2079,16 @@ completion latency measures how long it took for the other end to receive and
 send back. For UDP multicast traffic pingpong=1 should only be set for a single
 reader when multiple readers are listening to the same address.
 .TP
-.BI (net, window_size) \fR=\fPint
+.BI (net)window_size \fR=\fPint
 Set the desired socket buffer size for the connection.
 .TP
-.BI (net, mss) \fR=\fPint
+.BI (net)mss \fR=\fPint
 Set the TCP maximum segment size (TCP_MAXSEG).
 .TP
-.BI (e4defrag,donorname) \fR=\fPstr
+.BI (e4defrag)donorname \fR=\fPstr
 File will be used as a block donor (swap extents between files)
 .TP
-.BI (e4defrag,inplace) \fR=\fPint
+.BI (e4defrag)inplace \fR=\fPint
 Configure donor file block allocation strategy
 .RS
 .BI 0(default) :
-- 
2.9.4


