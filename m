Return-Path: <asias@redhat.com>
Message-ID: <4FB5EC0B.7010304@redhat.com>
Date: Fri, 18 May 2012 14:28:27 +0800
From: Asias He <asias@redhat.com>
MIME-Version: 1.0
Subject: Why fio triggers reading of device serial number
References: <4FB5EA0D.7030402@redhat.com>
In-Reply-To: <4FB5EA0D.7030402@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Hi, List

I noticed that fio triggers reading of device serial number when fio
starts (one read) and stops (lots of read). I was wondering if fio was
reading the sysfs attribute directly in fio's code,
e.g./sys/block/vda/serial, or it triggered something which make udevd to
read it.

trace-cmd shows it seems udevd is reading:

udevd-6856  [006] xxx: function:    dev_attr_show
udevd-6856  [006] xxx: function:        virtblk_serial_show

Any ideas? Thanks.


UDEV RULES
---------------
/lib/udev/rules.d/60-persistent-storage.rules

KERNEL=="vd*[!0-9]", ATTRS{serial}=="?*",
ENV{ID_SERIAL}="$attr{serial}", SYMLINK+="disk/by-id/virtio-$env{ID_SERIAL}"

KERNEL=="vd*[0-9]", ATTRS{serial}=="?*", ENV{ID_SERIAL}="$attr{serial}",
SYMLINK+="disk/by-id/virtio-$env{ID_SERIAL}-part%n"

FIO Config
-------------
[global]
bs=512
size=100G
direct=1
#ioengine=libaio
ioengine=sync
numjobs=256
filename=/dev/vda
thread
[seq-read-write]
rw=rw


-- 
Asias

