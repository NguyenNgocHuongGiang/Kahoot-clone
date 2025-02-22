import { ApiProperty } from '@nestjs/swagger';

export class CreateQuizSnapshotDto {
  @ApiProperty({
    description: 'ID of the session',
    example: 1,
  })
  sessionId: number;

  @ApiProperty({
    description: 'ID of the quiz',
    example: 1,
  })
  quizId: number;

  @ApiProperty({
    description: 'ID of the user',
    example: 1,
  })
  userId: number;

  @ApiProperty({
    description: 'Quiz data in JSON format',
    example: {
      quizTitle: 'text',
      questions: [
        {
          question_id: 1,
          question_text: "text",
          options: [
            {
              option_id: 1,
              option_text: 'text',
              is_correct: 1
            },
          ],
        },
      ],
    },
  })
  quizData: object;
}
