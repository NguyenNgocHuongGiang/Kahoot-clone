import { FileUploadController } from './file-upload.controller';
import { FileUploadService } from './file-upload.service';
import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { ConfigModule } from '@nestjs/config';
import * as multer from 'multer';

@Module({
  imports: [
    MulterModule.register({
        storage: multer.memoryStorage(),
        fileFilter: (req, file, callback) => {
            const allowedMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
            if (allowedMimeTypes.includes(file.mimetype)) {
              callback(null, true); // Accept file
            } else {
              callback(new Error('Only image files are allowed!'), false); // Reject file
            }
          },
    }),
    ConfigModule,
  ],
  controllers: [FileUploadController],
  providers: [FileUploadService],
})
export class FileUploadModule {}