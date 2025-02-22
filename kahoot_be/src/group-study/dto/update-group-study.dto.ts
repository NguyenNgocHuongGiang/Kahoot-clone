import { PartialType } from '@nestjs/swagger';
import { CreateGroupStudyDto } from './create-group-study.dto';

export class UpdateGroupStudyDto extends PartialType(CreateGroupStudyDto) {}
