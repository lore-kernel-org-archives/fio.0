Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388346AbfDROJm (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Apr 2019 10:09:42 -0400
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH fio] engines: Add Network Block Device (NBD) support.
Date: Thu, 18 Apr 2019 15:09:37 +0100
Message-Id: <20190418140938.15527-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: eblake@redhat.com, nbd@other.debian.org

Hi fio developers,

I'm attaching initial support for testing Network Block Device (NBD)
servers directly.  There are some problems with this patch, so it's
only for discussion.

At the moment you can test NBD servers indirectly by loop mounting a
filesystem using nbd.ko.  The loop mount method is described here:

  https://github.com/libguestfs/nbdkit/blob/master/BENCHMARKING

This tests rather a lot of machinery like the kernel and filesystems
which is not part of the NBD server, so I would like to extend fio
with an engine that supports NBD servers directly.

NBD servers (generally, not always) expose a single block device per
server.  You can usually make multiple connections to the server, and
all connections will see a single view of the device.  There is of
course no concept of files.

I'm having some problems understanding the execution model of fio: in
what order do engine methods get called?  how do threads correspond to
files?  are "jobs" the same as "files"?

Nevertheless I think I have mapped a single job to the NBD block
device.  You can test it using nbdkit plus a ramdisk like this:

  $ rm /tmp/socket
  $ nbdkit -U /tmp/socket memory size=1G --run './fio examples/nbd.fio'

If there are multiple jobs (files?) should these be striped over the
block device?

For some reason fio doesn't recognize the new --sockname parameter:

  $ ./fio examples/nbd.fio --sockname=foo
  ./fio: unrecognized option '--sockname=foo'
  ./fio: unrecognized option '--sockname=foo'

If this was fixed then you could use an implicit socket:

  $ nbdkit -U - memory size=1G \
           --run './fio examples/nbd.fio --sockname=$unixsocket'

The .queue method in this engine is synchronous.  It's possible for
multiple requests to be issued asynchronously on a single TCP socket,
but I don't know if it is worth doing this.

Although I said above that all connections to an NBD server see the
"same" view of the device, the view is not guaranteed to be consistent
*unless* the server returns the NBD_FLAG_CAN_MULTI_CONN export flag.
We do not check this currently (mainly because qemu-nbd does not set it).

Another problem is that we don't read the export size from the NBD
server until it's "too late" to use it to determine the file size.
Therefore users must take care to set a file size which is smaller
than the NBD export, although this isn't much of a problem in
practice.  I notice that the RBD engine works around this by
connecting to their server early (during .setup).

Here is how to test qemu-nbd, another popular NBD server:

  $ rm disk.img
  $ truncate -s 1G disk.img
  $ rm /tmp/socket
  $ qemu-nbd -f raw -t disk.img -k /tmp/socket
  $ ./fio examples/nbd.fio

Feedback welcome!

Rich.




