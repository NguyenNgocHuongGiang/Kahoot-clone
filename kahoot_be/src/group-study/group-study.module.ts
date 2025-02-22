import { Module } from '@nestjs/common';
import { GroupStudyService } from './group-study.service';
import { GroupStudyController } from './group-study.controller';
import { GroupStudyGateway } from './group-study.gateway';

@Module({
  controllers: [GroupStudyController],
  providers: [GroupStudyGateway, GroupStudyService],
})
export class GroupStudyModule {}
