Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/4] ioengine: File based ioengines
Date: Wed, 19 Sep 2012 23:22:52 +0400
Message-Id: <1348082576-10528-1-git-send-email-dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org, fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <fio@vger.kernel.org>

Fio is very cool tool for generating various io patterns.
And I use it as a base io-loader for xfsstress framework

I've prepared two file-based ioengines which allow to generate
interesting io patterns. 'falloc' is more generic and may be useful
for many cases, other 'e4defrag' is more specific but still
usfull. It would be nice to have this engines in-tree if possible.

TOC:
 # fixes for external engines
 export file_lookup_open
 ioengine: allow several external ioengines
 # file based ioengines
 ioengine: Add fallocate ioengine
 ioengine: Add e4defrag ioengine


