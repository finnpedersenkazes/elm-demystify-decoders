module Exercise10 exposing (Person, PersonDetails, Role(..), decoder)

import Json.Decode exposing (Decoder, at, field, list, map, map2, map3, string)



{- Let's try and do a complicated decoder, this time. No worries, nothing new
   here: applying the techniques you've used in the previous decoders should
   help you through this one.

   A couple of pointers:
    - try working "inside out". Write decoders for the details and role first
    - combine those decoders + the username and map them into the Person constructor
    - finally, wrap it all together to build it into a list of people


   Example input:

        [ { "username": "Phoebe"
          , "role": "regular"
          , "details":
            { "registered": "yesterday"
            , "aliases": [ "Phoebs" ]
            }
          }
        ]
-}


type alias Person =
    { username : String
    , role : Role
    , details : PersonDetails
    }


type alias PersonDetails =
    { registered : String
    , aliases : List String
    }


type Role
    = Newbie
    | Regular
    | OldFart


decoderPerson : Decoder Person
decoderPerson =
    map3 Person
        decoderUsername
        decoderRole
        decoderPersonDetails


decoderUsername : Decoder String
decoderUsername =
    field "username" string


decoderPersonDetails : Decoder PersonDetails
decoderPersonDetails =
    map2 PersonDetails
        (at [ "details", "registered" ] string)
        (at [ "details", "aliases" ] (list string))


decoderRole : Decoder Role
decoderRole =
    map stringToRole (field "role" string)


stringToRole : String -> Role
stringToRole roleString =
    case String.toLower roleString of
        "regular" ->
            Regular

        "oldfart" ->
            OldFart

        _ ->
            Newbie


decoder : Decoder (List Person)
decoder =
    list decoderPerson



{- Once you think you're done, run the tests for this exercise from the root of
   the project:

   - If you have installed `elm-test` globally:
        `elm test tests/Exercise10`

   - If you have installed locally using `npm`:
        `npm run elm-test tests/Exercise10`

   - If you have installed locally using `yarn`:
        `yarn elm-test tests/Exercise10`
-}
