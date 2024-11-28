package com.auth0.auth0_flutter.request_handlers.web_auth

import android.content.Context
import android.util.Log
import com.auth0.android.authentication.AuthenticationException
import com.auth0.android.callback.Callback
import com.auth0.android.provider.WebAuthProvider
import com.auth0.android.result.Credentials
import com.auth0.auth0_flutter.request_handlers.MethodCallRequest
import com.auth0.auth0_flutter.toMap
import io.flutter.plugin.common.MethodChannel
import java.text.SimpleDateFormat
import java.util.*

class LoginWebAuthRequestHandler(private val builderResolver: (MethodCallRequest) -> WebAuthProvider.Builder) : WebAuthRequestHandler {
    override val method: String = "webAuth#login"

    override fun handle(
        context: Context,
        request: MethodCallRequest,
        result: MethodChannel.Result
    ) {
        Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ handle called with request: $request")
        val builder = builderResolver(request)
        val args = request.data
        val scopes = (args["scopes"] ?: arrayListOf<String>()) as ArrayList<*>

        builder.withScope(scopes.joinToString(separator = " "))
        Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Scopes set: $scopes")

        if (args["audience"] is String) {
            builder.withAudience(args["audience"] as String)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Audience set: ${args["audience"]}")
        }

        if (args["redirectUrl"] is String) {
            builder.withRedirectUri(args["redirectUrl"] as String)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Redirect URL set: ${args["redirectUrl"]}")
        }

        if (args["organizationId"] is String) {
            builder.withOrganization(args["organizationId"] as String)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Organization ID set: ${args["organizationId"]}")
        }

        if (args["invitationUrl"] is String) {
            builder.withInvitationUrl(args["invitationUrl"] as String)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Invitation URL set: ${args["invitationUrl"]}")
        }

        if (args["leeway"] is Int) {
            builder.withIdTokenVerificationLeeway(args["leeway"] as Int)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Leeway set: ${args["leeway"]}")
        }

        if (args["maxAge"] is Int) {
            builder.withMaxAge(args["maxAge"] as Int)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Max Age set: ${args["maxAge"]}")
        }

        if (args["issuer"] is String) {
            builder.withIdTokenVerificationIssuer(args["issuer"] as String)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Issuer set: ${args["issuer"]}")
        }

        if (args["scheme"] is String) {
            builder.withScheme(args["scheme"] as String)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Scheme set: ${args["scheme"]}")
        }

        if (args["parameters"] is Map<*, *>) {
            builder.withParameters(args["parameters"] as Map<String, *>)
            Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Parameters set: ${args["parameters"]}")
        }

        builder.start(context, object : Callback<Credentials, AuthenticationException> {
            override fun onFailure(exception: AuthenticationException) {
                Log.e("LoginWebAuthRequestHandler", "@@@@@@@@@@ Authentication failed: ${exception.getDescription()}")
                result.error(exception.getCode(), exception.getDescription(), exception)
            }

            override fun onSuccess(credentials: Credentials) {
                Log.d("LoginWebAuthRequestHandler", "@@@@@@@@@@ Authentication succeeded")
                val scopes = credentials.scope?.split(" ") ?: listOf()
                val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
                val formattedDate = sdf.format(credentials.expiresAt)

                result.success(
                    mapOf(
                        "accessToken" to credentials.accessToken,
                        "idToken" to credentials.idToken,
                        "refreshToken" to credentials.refreshToken,
                        "userProfile" to credentials.user.toMap(),
                        "expiresAt" to formattedDate,
                        "scopes" to scopes,
                        "tokenType" to credentials.type
                    )
                )
            }
        })
    }
}
