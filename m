Return-Path: <sbohrer@rgmadvisors.com>
MIME-Version: 1.0
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
Subject: [PATCH] net: Add UDP multicast example job file
Date: Mon, 22 Jul 2013 09:57:44 -0500
Message-Id: <1374505064-5246-1-git-send-email-sbohrer@rgmadvisors.com>
In-Reply-To: <20130722145456.GA3509@sbohrermbp13-local.rgmadvisors.com>
References: <20130722145456.GA3509@sbohrermbp13-local.rgmadvisors.com>
Content-Type: text/plain; charset=US-ASCII
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, tomk@rgmadvisors.com, Shawn Bohrer <sbohrer@rgmadvisors.com>
List-ID: <fio@vger.kernel.org>

This adds a pingpong UDP multicast example with two readers.

Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
---
 examples/netio_multicast.fio |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 examples/netio_multicast.fio

diff --git a/examples/netio_multicast.fio b/examples/netio_multicast.fio
new file mode 100644
index 0000000..f7d9d26
--- /dev/null
+++ b/examples/netio_multicast.fio
@@ -0,0 +1,23 @@
+# netio UDP multicast example. Writers and readers can be run on separate hosts.
+[global]
+ioengine=net
+protocol=udp
+bs=64
+size=100m
+# Set interface IP to send/receive traffic through specific network interface
+#interface=10.8.16.22
+port=10000
+hostname=239.0.0.0
+ttl=1
+
+[pingpong_reader]
+pingpong=1
+rw=read
+
+[normal_reader]
+rw=read
+
+[pingpong_writer]
+startdelay=1
+pingpong=1
+rw=write
-- 
1.7.7.6


-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

