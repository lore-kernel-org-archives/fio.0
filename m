Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 0/2] cross-job overlap patches
Date: Tue, 16 Oct 2018 11:26:48 -0400
Message-Id: <20181016152650.7784-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jens, please consider these two patches related to cross-job overlap checking:

- Better document how locking is used in cross-job overlap checking
- Force threads when checking overlap across jobs in offload mode



